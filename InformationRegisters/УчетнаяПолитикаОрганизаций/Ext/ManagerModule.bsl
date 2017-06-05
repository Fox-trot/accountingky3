﻿#Область СлужебныеПроцедурыИФункции

Процедура ПервоначальноеЗаполнение() Экспорт
	
	НаборЗаписей = РегистрыСведений.УчетнаяПолитикаОрганизаций.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 1 Тогда 
		Сообщить("Учетная политика заполнена!!!");
		Возврат;
	КонецЕсли;
	
	НаборЗаписей.Очистить();
	
	СНЗ = НаборЗаписей.Добавить();
	СНЗ.Период      	= '20150101';
	СНЗ.Организация 	= Справочники.Организации.ОсновнаяОрганизация;
	СНЗ.ПлательщикНДС   = Истина;
	СНЗ.ПлательщикНСП   = Истина;
	СНЗ.ПлательщикНП    = Истина;
	СНЗ.УчетНДСНаАвансы = Истина;
	СНЗ.МинимумСтоимостиОСДляНУ 		= 10000;
	СНЗ.НормаВычетаПриПоступленииОС 	= 0;
	СНЗ.ПредельнаяНормаНаРемонтОС   	= 15;
	СНЗ.МинимальнаяСтоимостьГруппыОС	= 10000;
	СНЗ.ВидУчетаИзносаМБП           	= Перечисления.ВидыУчетаИзносаМБП.ПоловинуПриВводе;
	СНЗ.СтавкаНСППоУмолчанию        	= Справочники.СтавкиНСП.Прочее;
	СНЗ.СтавкаНДСПоУмолчанию        	= Справочники.СтавкиНДС.Стандарт;
	НаборЗаписей.Записать();
КонецПроцедуры	

#КонецОбласти