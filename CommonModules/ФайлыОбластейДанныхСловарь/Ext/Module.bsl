﻿
#Область СлужебныйПрограммныйИнтерфейс

Функция КорневоеСобытие() Экспорт
	
	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Файлы областей данных';
				|en = 'Data area files'", КодЯзыка);
	
КонецФункции

Функция ФайлНеНайденПоИдентификатору() Экспорт
	Возврат НСтр("ru = 'Файл с идентификатором ''%1'' не найден.';
				|en = 'File with ID ''%1'' is not found.'");
КонецФункции

Функция ФайлНеНайденПоПолномуИмени() Экспорт
	Возврат НСтр("ru = 'Файл ''%1'' не найден.';
				|en = 'File ""%1"" not found.'");
КонецФункции

Функция ИмяФайлаДляСохраненияНеЗадано() Экспорт
	Возврат НСтр("ru = 'Не задано имя файла для сохранения.';
				|en = 'File name for saving is not specified.'");
КонецФункции

Функция ИнформацияОФайлеОтсутствует() Экспорт
	Возврат НСтр("ru = 'Отсутствует информация о файле.';
				|en = 'No information on file.'");
КонецФункции

Функция НеверныйТипЗаданияФайла() Экспорт
	Возврат НСтр("ru = 'Неверный тип задания файла.';
				|en = 'Invalid file specification type.'");
КонецФункции

Функция УдалениеФайлаИзХранилища() Экспорт
	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Удаление файла из хранилища.';
				|en = 'Delete file from storage.'", КодЯзыка);
КонецФункции

Функция УдалениеФайлаТома() Экспорт
	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Удаление файла тома';
				|en = 'Delete volume file'", КодЯзыка);	
КонецФункции

Функция УстановкаПризнакаВременный() Экспорт
	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Установка признака ''Временный''.';
				|en = 'Select the Temporary check box.'", КодЯзыка);
КонецФункции

Функция ПереданИдентификаторНекорректногоТипа() Экспорт 
	
	Возврат НСтр("ru = 'Передан идентификатор некорректного типа. Ожидается: УникальныйИдентификатор, получено: %1';
				|en = 'ID of incorrect type is passed. Awaited: УникальныйИдентификатор, received: %1'");
	
КонецФункции

Функция НельзяЗаписыватьДанныеПриВключенномРазделенииБезУказанияРазделителя() Экспорт
	
	Возврат НСтр("ru = 'Нельзя записывать данные при включенном разделении без указания разделителя.';
				|en = 'You must not record the data when the separation is on without specification of a separator.'");
	
КонецФункции

#КонецОбласти 
