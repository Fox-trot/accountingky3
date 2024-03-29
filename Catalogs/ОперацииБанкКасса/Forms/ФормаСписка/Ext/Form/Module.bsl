﻿
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьДокумент(Команда)
	
	ВыбранныйЭлемент = Элементы.Список.ТекущиеДанные;
	
	Если ВыбранныйЭлемент <> Неопределено Тогда	
		СтруктураДанных = Новый Структура();
		СтруктураДанных.Вставить("Операции", Истина);	
		СтруктураДанных.Вставить("КорСчет", ВыбранныйЭлемент.КорСчет);
		СтруктураДанных.Вставить("ВидОперации", ВыбранныйЭлемент.ВидОперации);
		
		Если ВыбранныйЭлемент.ВидДокумента = "РКО" Тогда
			ОткрытьФорму("Документ.РасходныйКассовыйОрдер.Форма.ФормаДокумента", СтруктураДанных);
		Иначе
			ОткрытьФорму("Документ.ПлатежноеПоручениеИсходящее.Форма.ФормаДокумента", СтруктураДанных);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти