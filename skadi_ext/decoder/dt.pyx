from skadi.decoder import recv_prop as dcdr_rcvprp
from skadi.state.util import Prop


cpdef DTDecoder mk(object recv_table):
    return DTDecoder(recv_table)


cdef object cache = dict()


cdef class DTDecoder(object):
    def __init__(DTDecoder self, object recv_table):
        self.recv_table = recv_table
        self.by_index = []
        self.by_recv_prop = dict()

        for recv_prop in recv_table:
            if recv_prop not in cache:
                cache[recv_prop] = dcdr_rcvprp.mk(recv_prop)
            recv_prop_decoder = cache[recv_prop]

            self.by_index.append(recv_prop_decoder)
            self.by_recv_prop[recv_prop] = recv_prop_decoder

    def __iter__(DTDecoder self):
        for recv_prop, recv_prop_decoder in self.by_recv_prop.items():
            yield recv_prop, recv_prop_decoder

        raise StopIteration()

    cpdef object decode(DTDecoder self, object stream, object prop_list):
        return dict([(i, self.by_index[i].decode(stream)) for i in prop_list])
